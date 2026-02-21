import strawberry
from .schedule import ScheduleQuery
from .recall import RecallMutation

@strawberry.type
class Query(ScheduleQuery): 
    pass

@strawberry.type
class Mutation(RecallMutation):
    pass

schema = strawberry.Schema(query=Query, mutation=Mutation)