-- IdentityForge: Portable Department Entitlement Seed
-- Safe to rerun; does not grant actual directory permissions.

INSERT INTO department_entitlements (department_id, group_id)
SELECT
    d.department_id,
    g.group_id
FROM (
    VALUES
        ('Information Technology', 'GG-DEPT-IT-BASE'),
        ('Cybersecurity', 'GG-DEPT-CYBER-BASE'),
        ('Human Resources', 'GG-DEPT-HR-BASE'),
        ('Finance', 'GG-DEPT-FINANCE-BASE'),
        ('Legal', 'GG-DEPT-LEGAL-BASE'),
        ('Operations', 'GG-DEPT-OPS-BASE'),
        ('Marketing', 'GG-DEPT-MARKETING-BASE'),
        ('Sales', 'GG-DEPT-SALES-BASE'),
        ('Engineering', 'GG-DEPT-ENGINEERING-BASE'),
        ('Compliance', 'GG-DEPT-COMPLIANCE-BASE')
) AS mappings(department_name, group_name)
JOIN departments d
    ON d.department_name = mappings.department_name
JOIN access_groups g
    ON g.group_name = mappings.group_name
WHERE g.is_privileged = FALSE
ON CONFLICT (department_id, group_id) DO NOTHING;
