from fractions import Fraction
from libc.stdint cimport int64_t, uint8_t, uint64_t
cimport libav as lib


# Would love to use the built-in constant, but it doesn't appear to
# exist on Travis, or my Linux workstation. Could this be because they
# are actually libav?
cdef int AV_ERROR_MAX_STRING_SIZE = 64


class AVError(EnvironmentError):
    pass
AVError.__module__ = 'av'


cdef int err_check(int res, filename=None) except -1:
    cdef bytes py_buffer
    cdef char *c_buffer
    if res < 0:
        py_buffer = b"\0" * AV_ERROR_MAX_STRING_SIZE
        c_buffer = py_buffer
        lib.av_strerror(res, c_buffer, AV_ERROR_MAX_STRING_SIZE)
        if filename:
            raise AVError(-res, c_buffer, filename)
        else:
            raise AVError(-res, c_buffer)
    return res


cdef dict avdict_to_dict(lib.AVDictionary *input):
    
    cdef lib.AVDictionaryEntry *element = NULL
    cdef dict output = {}
    while True:
        element = lib.av_dict_get(input, "", element, lib.AV_DICT_IGNORE_SUFFIX)
        if element == NULL:
            break
        output[element.key] = element.value
    return output


cdef dict_to_avdict(lib.AVDictionary **dst, dict src, bint clear=True):
    
    if clear:
        lib.av_dict_free(dst)

    cdef bytes key_str, value_str
    for key, value in src.iteritems():
        key_str = str(key)
        value_str = str(value)
        err_check(lib.av_dict_set(dst, key_str, value_str, 0))


cdef object avrational_to_faction(lib.AVRational *input):
    return Fraction(input.num, input.den) if input.den else Fraction(0, 1)


cdef object to_avrational(object value, lib.AVRational *input):

    if isinstance(value, Fraction):
        frac = value
    else:
        frac = Fraction(value)

    input.num = frac.numerator
    input.den = frac.denominator


cdef object av_frac_to_fraction(lib.AVFrac *input):
    return Fraction(input.val * input.num, input.den)

