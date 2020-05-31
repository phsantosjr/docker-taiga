from kombu import Queue

broker_url = "amqp://$RABBITMQ_DEFAULT_USER:$RABBIT_DEFAULT_PASS@$RABBIT_HOST:$RABBIT_PORT/$RABBIT_DEFAULT_VHOST"
result_backend = 'redis://anything:$REDIS_PASSWORD@$REDIS_HOST:$REDIS_PORT/$REDIS_DB'

accept_content = ['pickle',] # Values are 'pickle', 'json', 'msgpack' and 'yaml'
task_serializer = "pickle"
result_serializer = "pickle"

timezone = 'America/Sao_Paulo'

task_default_queue = 'tasks'
task_queues = (
    Queue('tasks', routing_key='task.#'),
    Queue('transient', routing_key='transient.#', delivery_mode=1)
)
task_default_exchange = 'tasks'
task_default_exchange_type = 'topic'
task_default_routing_key = 'task.default'
