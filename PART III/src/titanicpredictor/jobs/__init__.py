def make_job_decorator():
    registry = {}

    def register(name):
        def inner(func):
            registry[name] = func
            return func

        return inner

    register.all = registry
    return register


entrypoint = make_job_decorator()
