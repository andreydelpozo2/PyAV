
cdef class Packet(object):
    
    """A packet of encoded data within a :class:`~av.format.Stream`.

    This may, or may not include a complete object within a stream.
    :meth:`decode` must be called to extract encoded data.

    """
    def __init__(self):
        lib.av_init_packet(&self.struct)

    def __dealloc__(self):
        lib.av_free_packet(&self.struct)
    
    def __repr__(self):
        return '<av.%s of %s at 0x%x>' % (
            self.__class__.__name__,
            self.stream,
            id(self),
        )
    
    def decode(self):
        """Decode the data in this packet into a list of Frames."""
        return self.stream.decode(self)

    property pts:
        def __get__(self): return None if self.struct.pts == lib.AV_NOPTS_VALUE else self.struct.pts
    property dts:
        def __get__(self): return None if self.struct.dts == lib.AV_NOPTS_VALUE else self.struct.dts
    property size:
        def __get__(self): return self.struct.size
    property duration:
        def __get__(self): return None if self.struct.duration == lib.AV_NOPTS_VALUE else self.struct.duration

