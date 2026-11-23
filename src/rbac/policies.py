from src.database import get_connection
from src.rbac.engine import get_authorized_groups
from src.rbac.validators import validate_separation_of_duties


def evaluate_employee_access(employee_number):
    """Evaluate eligibility for standard RBAC access."""

    with get_connection() as conn:
        employee = conn.execute(
            """
            SELECT employee_number, employment_status
            FROM employees
            WHERE employee_number = %s
            """,
            (employee_number,),
        ).fetchone()

    if employee is None:
        return {
            "employee_number": employee_number,
            "decision": "DENY",
            "reason": "Employee not found",
            "authorized_groups": [],
        }

    if employee[1] != "Active":
        return {
            "employee_number": employee_number,
            "decision": "DENY",
            "reason": f"Employee status is {employee[1]}",
            "authorized_groups": [],
        }

    groups = get_authorized_groups(employee_number)

    if not groups:
        return {
            "employee_number": employee_number,
            "decision": "DENY",
            "reason": "No approved standard entitlements",
            "authorized_groups": [],
        }

    group_names = [group["group_name"] for group in groups]
    sod_result = validate_separation_of_duties(group_names)

    if not sod_result["compliant"]:
        return {
            "employee_number": employee_number,
            "decision": "DENY",
            "reason": "Separation-of-duties violation",
            "authorized_groups": [],
            "violations": sod_result["violations"],
        }

    return {
        "employee_number": employee_number,
        "decision": "ELIGIBLE",
        "reason": "Active employee with compliant standard entitlements",
        "authorized_groups": groups,
    }
