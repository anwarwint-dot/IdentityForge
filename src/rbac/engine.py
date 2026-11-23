from psycopg.rows import dict_row

from src.database import get_connection


def get_authorized_groups(employee_number):
    """Calculate approved standard access from role and department."""

    query = """
        WITH employee_access AS (
            SELECT
                e.employee_number,
                e.employment_status,
                e.department_id,
                e.role_id
            FROM employees e
            WHERE e.employee_number = %s
        ),
        approved_groups AS (
            SELECT re.group_id
            FROM employee_access e
            JOIN role_entitlements re
                ON e.role_id = re.role_id
            WHERE e.employment_status = 'Active'

            UNION

            SELECT de.group_id
            FROM employee_access e
            JOIN department_entitlements de
                ON e.department_id = de.department_id
            WHERE e.employment_status = 'Active'
        )
        SELECT
            g.group_id,
            g.group_name,
            g.system_name
        FROM approved_groups ag
        JOIN access_groups g
            ON ag.group_id = g.group_id
        WHERE g.is_privileged = FALSE
        ORDER BY g.group_name
    """

    with get_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cursor:
            cursor.execute(query, (employee_number,))
            return cursor.fetchall()
