v = "v"


def default_version(version):
    if version.startswith(v):
        version = version[len(v):]

    numbers = version.split('.')
    for number in numbers:
        if not number.isnumeric():
            return (0, )
    return tuple([int(number) for number in numbers])


version_types = {
    'default': default_version,
}
