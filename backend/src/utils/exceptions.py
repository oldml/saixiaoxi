class SaixiaoxiException(Exception):
    def __init__(self, message: str, details: dict = None):
        self.message = message
        self.details = details or {}
        super().__init__(self.message)

class ConnectionError(SaixiaoxiException):
    pass


class AuthenticationError(SaixiaoxiException):
    pass


class QueryError(SaixiaoxiException):
    pass


class TimeoutError(SaixiaoxiException):
    pass


class ParseError(SaixiaoxiException):

    pass


class ServiceNotReadyError(SaixiaoxiException):
    pass


class ValidationError(SaixiaoxiException):
    pass
