from src.database import get_connection


def test_enterprise_identity_data():
    """Validate enterprise IAM data integrity."""

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    COUNT(*),
                    COUNT(DISTINCT employee_number),
                    COUNT(DISTINCT email),
                    COUNT(*) FILTER (
                        WHERE department_id IS NULL
                           OR role_id IS NULL
                    )
                FROM employees
            """)

            total, unique_numbers, unique_emails, missing = cur.fetchone()

            assert total == 5000
            assert unique_numbers == total
            assert unique_emails == total
            assert missing == 0

            cur.execute("SELECT COUNT(*) FROM departments")
            assert cur.fetchone()[0] == 50

            cur.execute("SELECT COUNT(*) FROM access_groups")
            assert cur.fetchone()[0] == 300

            cur.execute("SELECT COUNT(*) FROM role_entitlements")
            assert cur.fetchone()[0] == 40

            cur.execute("""
                SELECT COUNT(*)
                FROM role_entitlements re
                JOIN access_groups g
                    ON re.group_id = g.group_id
                WHERE g.is_privileged = TRUE
            """)

            assert cur.fetchone()[0] == 0
