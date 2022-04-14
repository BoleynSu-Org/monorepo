import johnnydep


def update(dep):
    dist = johnnydep.JohnnyDist(dep["name"])
    dep["version"] = dist.version_latest
    return dep
