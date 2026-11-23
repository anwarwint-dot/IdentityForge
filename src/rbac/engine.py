from psycopg.rows import dict_row

from src.database import get_connection


def get_authorized_groups(employee_number):
    """Retrieve nonprivileged RBAC entitlements for an employee."""

    query = """
        SELECT
            e.employee_number,
            r.role_name,
            g.group_id,
            g.group_name,
            g.system_name
        FROM employees AS e
        JOIN job_roles AS r
            ON e.role_id = r.role_id
        JOIN role_entitlements AS re
            ON r.role_id = re.role_id
        JOIN access_groups AS g
            ON re.group_id = g.group_id
        WHERE e.employee_number = %s
          AND e.employment_status = 'Active'
          AND g.is_privileged = FALSE
        ORDER BY g.group_name
    """

    with get_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cursor:
            cursor.execute(query, (employee_number,))
            return cursor.fetchall()
