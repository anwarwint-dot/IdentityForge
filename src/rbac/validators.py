"""IdentityForge separation-of-duties validation."""

# Illustrative policies for synthetic enterprise access groups.
# These are not actual production-approved policies.
SOD_CONFLICTS = {
    frozenset({
        "GG-Finance-Payment-Creators",
        "GG-Finance-Payment-Approvers",
    }),
    frozenset({
        "GG-Identity-Access-Requesters",
        "GG-Identity-Access-Approvers",
    }),
}


def validate_separation_of_duties(group_names):
    """Identify conflicting access group combinations."""

    assigned_groups = set(group_names)
    violations = []

    for conflict in SOD_CONFLICTS:
        if conflict.issubset(assigned_groups):
            violations.append(sorted(conflict))

    return {
        "compliant": len(violations) == 0,
        "violations": violations,
    }
