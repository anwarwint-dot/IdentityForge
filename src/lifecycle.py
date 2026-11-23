import logging

from psycopg.rows import dict_row

from src.database import get_connection


logger = logging.getLogger(__name__)


def get_pending_events():
    """Retrieve pending identity lifecycle events."""

    query = """
        SELECT
            le.event_id,
            le.correlation_id,
            e.employee_number,
            e.first_name,
            e.last_name,
            le.event_type,
            le.event_status,
            le.created_at
        FROM lifecycle_events AS le
        JOIN employees AS e
            ON le.employee_id = e.employee_id
        WHERE le.event_status = %s
        ORDER BY le.created_at, le.event_id
    """

    with get_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cursor:
            cursor.execute(query, ("Pending",))
            events = cursor.fetchall()

    logger.info("Retrieved %d pending lifecycle events", len(events))
    return events
