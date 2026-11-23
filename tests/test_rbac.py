from unittest.mock import patch

from src.rbac.policies import evaluate_employee_access
from src.rbac.validators import validate_separation_of_duties


def test_active_employee_is_eligible():
    result = evaluate_employee_access("EMP001")

    assert result["decision"] == "ELIGIBLE"
    assert set(g["group_name"] for g in result["authorized_groups"]) == {"GG-DEPT-IT-BASE", "GG-IAM-Users"}


def test_onboarding_employee_is_denied():
    result = evaluate_employee_access("EMP009")

    assert result["decision"] == "DENY"
    assert result["authorized_groups"] == []


def test_nonexistent_employee_is_denied():
    result = evaluate_employee_access("EMP999999")

    assert result["decision"] == "DENY"
    assert result["authorized_groups"] == []


def test_sod_conflict_detection():
    groups = [
        "GG-Finance-Payment-Creators",
        "GG-Finance-Payment-Approvers",
    ]

    result = validate_separation_of_duties(groups)

    assert result["compliant"] is False
    assert len(result["violations"]) == 1


def test_policy_engine_denies_sod_conflict():
    conflicting_groups = [
        {
            "group_name": "GG-Finance-Payment-Creators",
            "system_name": "Active Directory",
        },
        {
            "group_name": "GG-Finance-Payment-Approvers",
            "system_name": "Active Directory",
        },
    ]

    with patch(
        "src.rbac.policies.get_authorized_groups",
        return_value=conflicting_groups,
    ):
        result = evaluate_employee_access("EMP001")

    assert result["decision"] == "DENY"
    assert result["reason"] == "Separation-of-duties violation"
    assert len(result["violations"]) == 1

