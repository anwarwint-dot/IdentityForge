-- IdentityForge: Department Baseline Access Groups
-- Synthetic lab groups; no actual directory permissions granted.

INSERT INTO access_groups (
    group_name,
    group_description,
    system_name,
    is_privileged
)
SELECT
    'GG-DEPT-' || code || '-BASE',
    'Baseline departmental access - synthetic lab policy',
    'Active Directory',
    FALSE
FROM (
    VALUES
        ('IT'),
        ('CYBER'),
        ('HR'),
        ('FINANCE'),
        ('LEGAL'),
        ('OPS'),
        ('MARKETING'),
        ('SALES'),
        ('ENGINEERING'),
        ('COMPLIANCE')
) AS departments(code)
ON CONFLICT (group_name) DO NOTHING;
