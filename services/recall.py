from sqlalchemy import select, desc
from sqlalchemy.ext.asyncio import AsyncSession
from models import StudyLog
from datetime import date

async def record_result(user_id: int, topic_id: int, is_correct: bool, db: AsyncSession):
    stmt = (
        select(StudyLog)
        .where(StudyLog.user_id == user_id, StudyLog.topic_id == topic_id)
        .order_by(StudyLog.id)
        .limit(1)
    )

    result = await db.execute(stmt)
    log = result.scalar()

    if log:
        if is_correct:
            log.understanding_level = min(log.understanding_level + 1, 5)
        else:
            log.understanding_level = 0
        log.study_on = date.today()
    else:
        new_level = 1 if is_correct else 0
        log = StudyLog(
            user_id=user_id,
            topic_id=topic_id,
            understanding_level=new_level,
            study_on=date.today()
        )
        db.add(log)

    await db.commit()
    await db.refresh(log)
    return log