import strawberry
from datetime import date
from ..services.schedule import get_daily_stats

@strawberry.type
class DailyGoal:
    remaining_topics: int
    days_left: int
    topics_per_day: float

@strawberry.type
class ScheduleQuery:
    @strawberry.field
    async def schedule_analysis(self, info: strawberry.Info, target_date: date) -> DailyGoal:
        user_id = 1 
        db = info.context.get("db") 
        
        if db is None:
            raise Exception("Database session not found in context")

        stats = await get_daily_stats(user_id, target_date, db)
        return DailyGoal(**stats)
