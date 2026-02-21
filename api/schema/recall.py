import strawberry
from ..services.recall import record_result 

@strawberry.type
class RecallResponse:
    status: str
    topic_id: int
    new_level: int

@strawberry.type
class RecallMutation:
    @strawberry.field
    async def record_recall_result(
        self, 
        info: strawberry.Info, 
        topic_id: int, 
        is_correct: bool
    ) -> RecallResponse:
        db = info.context.get("db")
        user_id = 1

        log = await record_result(user_id, topic_id, is_correct, db)
        
        return RecallResponse(
            status="success",
            topic_id=log.topic_id,
            new_level=log.understanding_level
        )