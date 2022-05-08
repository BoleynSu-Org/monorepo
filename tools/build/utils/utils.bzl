def resolve_conflicts(base, *delta):
    base = dict(base)
    for artifacts in delta:
        for name, data in artifacts.items():
            if name not in base:
                base[name] = data
    return base
