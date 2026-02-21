from datetime import date
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from ..models import Topic, StudyLog

async def get_daily_stats(user_id: int, target_date: date, db: AsyncSession):
    # 1. 全論点数 (Total Topics)
    total_stmt = select(func.count(Topic.id))
    total_res = await db.execute(total_stmt)
    total_count = total_res.scalar() or 0

    # 2. 完了済み論点数 (Unique topics with understanding_level >= 3)
    done_stmt = (
        select(func.count(func.distinct(StudyLog.topic_id)))
        .where(StudyLog.user_id == user_id)
        .where(StudyLog.understanding_level >= 3)
    )
    done_res = await db.execute(done_stmt)
    done_count = done_res.scalar() or 0

    # 3. 逆算計算
    remaining = total_count - done_count
    today = date.today()
    days_left = (target_date - today).days

    # 期限切れや当日などのエッジケース対策
    safe_days_left = max(days_left, 1)
    pace = round(remaining / safe_days_left, 1)

    return {
        "remaining_topics": remaining,
        "days_left": days_left,
        "topics_per_day": pace
    }