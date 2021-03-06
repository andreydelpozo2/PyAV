from libc.stdint cimport int64_t, uint8_t, uint64_t

cdef extern from "libavutil_compat.h" nogil:
    pass

cdef extern from "libavutil/mathematics.h" nogil:
    pass

cdef extern from "libavutil/avutil.h" nogil:

    cdef enum AVPixelFormat:
        AV_PIX_FMT_NONE
        AV_PIX_FMT_YUV420P
        AV_PIX_FMT_RGB24
        PIX_FMT_RGB24
        PIX_FMT_RGBA
        
    cdef enum AVSampleFormat:
        AV_SAMPLE_FMT_NONE
        AV_SAMPLE_FMT_S16
        AV_SAMPLE_FMT_FLTP
        
    cdef enum AVRounding:
        AV_ROUND_ZERO
        AV_ROUND_INF
        AV_ROUND_DOWN
        AV_ROUND_UP
        AV_ROUND_NEAR_INF
        AV_ROUND_PASS_MINMAX
    
    cdef int AV_ERROR_MAX_STRING_SIZE
    cdef int AVERROR_EOF
    
    cdef int AV_CH_LAYOUT_STEREO
    
    cdef int ENOMEM
    
    cdef int EAGAIN
    
    cdef double M_PI
    
    cdef int AVERROR(int error)
    cdef int av_strerror(int errno, char *output, size_t output_size)
    cdef char* av_err2str(int errnum)

    cdef void* av_malloc(size_t size)
    cdef void *av_calloc(size_t nmemb, size_t size)
    
    cdef void av_free(void* ptr)
    cdef void av_freep(void *ptr)
    
    cdef int av_get_bytes_per_sample(AVSampleFormat sample_fmt)
    
    cdef int av_samples_get_buffer_size(
        int *linesize,
        int nb_channels,
        int nb_samples,
        AVSampleFormat sample_fmt,
        int align
    )
    
    # See: http://ffmpeg.org/doxygen/trunk/structAVRational.html
    ctypedef struct AVRational:
        int num
        int den
        
    cdef AVRational AV_TIME_BASE_Q
    
    # Rescales from one time base to another
    cdef int64_t av_rescale_q(
        int64_t a, # time stamp
        AVRational bq, # source time base
        AVRational cq  # target time base
    )
    
    # Rescale a 64-bit integer with specified rounding.
    # A simple a*b/c isn't possible as it can overflow
    cdef int64_t av_rescale_rnd(
        int64_t a,
        int64_t b, 
        int64_t c,
        AVRounding r
    )
    
    cdef int64_t av_rescale(
        int64_t a, 
        int64_t b, 
        int64_t c
    )
    
    cdef char* av_strdup(char *s)
    
    cdef int av_opt_set_int(
        void *obj,
        char *name,
        int64_t value,
        int search_flags
    )

cdef extern from "libavutil/pixdesc.h" nogil:


    # See: http://ffmpeg.org/doxygen/trunk/structAVComponentDescriptor.html
    cdef struct AVComponentDescriptor:
        # These are bitfields, but this should generate the right C anyways.
        unsigned int plane
        unsigned int step_minus1
        unsigned int offset_plus1
        unsigned int shift
        unsigned int depth_minus1

    cdef enum AVPixFmtFlags:
        PIX_FMT_BE
        PIX_FMT_PAL
        PIX_FMT_BITSTREAM
        PIX_FMT_HWACCEL
        PIX_FMT_PLANAR
        PIX_FMT_RGB

    # See: http://ffmpeg.org/doxygen/trunk/structAVPixFmtDescriptor.html
    cdef struct AVPixFmtDescriptor:
        const char *name
        uint8_t nb_components
        uint8_t log2_chroma_w
        uint8_t log2_chroma_h
        uint8_t flags
        AVComponentDescriptor comp[4]

    cdef AVPixFmtDescriptor* av_pix_fmt_desc_get(AVPixelFormat pix_fmt)
    cdef AVPixFmtDescriptor* av_pix_fmt_desc_next(AVPixFmtDescriptor *prev)

    cdef char * av_get_pix_fmt_name(AVPixelFormat pix_fmt)
    cdef AVPixelFormat av_get_pix_fmt(char* name)


        
    
cdef extern from "libavutil/audioconvert.h" nogil:
    
    # Layouts.
    cdef uint64_t av_get_channel_layout(char* name)
    cdef int av_get_channel_layout_nb_channels(uint64_t channel_layout)
    cdef int64_t av_get_default_channel_layout(int nb_channels)
    cdef void av_get_channel_layout_string(
        char* buff,
        int buf_size,
        int nb_channels,
        uint64_t channel_layout
    )

    # Channels.
    cdef uint64_t av_channel_layout_extract_channel(uint64_t layout, int index)
    cdef char* av_get_channel_name(uint64_t channel)
    cdef char* av_get_channel_description(uint64_t channel)

    
    
    
cdef extern from "libavutil/audio_fifo.h" nogil:
    
    cdef struct AVAudioFifo:
        pass
    
    cdef void av_audio_fifo_free(AVAudioFifo *af)
    
    cdef AVAudioFifo* av_audio_fifo_alloc(
         AVSampleFormat sample_fmt,
         int channels,
         int nb_samples
    )
    
    cdef int av_audio_fifo_write(
        AVAudioFifo *af, 
        void **data, 
        int nb_samples
    )
    
    cdef int av_audio_fifo_read(
        AVAudioFifo *af,
        void **data, 
        int nb_samples
    )
    
    cdef int av_audio_fifo_size(AVAudioFifo *af)
    cdef int av_audio_fifo_space (AVAudioFifo *af)


cdef extern from "stdarg.h" nogil:

    # For logging. Should really be in another PXD.
    ctypedef struct va_list:
        pass


cdef extern from "Python.h" nogil:

    # For logging. See av/logging.pyx for an explanation.
    cdef int Py_AddPendingCall(void *, void *)
    void PyErr_PrintEx(int set_sys_last_vars)
    int Py_IsInitialized()
    void PyErr_Display(object, object, object)


cdef extern from "stdio.h" nogil:

    cdef int vasprintf(
        char **output,
        const char *format,
        va_list ap
    )


cdef extern from "libavutil/log.h" nogil:

    cdef enum AVClassCategory:
        AV_CLASS_CATEGORY_NA    
        AV_CLASS_CATEGORY_INPUT     
        AV_CLASS_CATEGORY_OUTPUT    
        AV_CLASS_CATEGORY_MUXER     
        AV_CLASS_CATEGORY_DEMUXER   
        AV_CLASS_CATEGORY_ENCODER   
        AV_CLASS_CATEGORY_DECODER   
        AV_CLASS_CATEGORY_FILTER    
        AV_CLASS_CATEGORY_BITSTREAM_FILTER  
        AV_CLASS_CATEGORY_SWSCALER  
        AV_CLASS_CATEGORY_SWRESAMPLER   
        AV_CLASS_CATEGORY_NB

    cdef struct AVClass:
        const char *class_name
        const char *(*item_name)(void*) nogil
        AVClassCategory category
        int parent_log_context_offset

    int AV_LOG_QUIET
    int AV_LOG_PANIC
    int AV_LOG_FATAL
    int AV_LOG_ERROR
    int AV_LOG_WARNING
    int AV_LOG_INFO
    int AV_LOG_VERBOSE
    int AV_LOG_DEBUG

    int av_log_get_level()
    void av_log_set_level(int)

    # Send a log.
    void av_log(void *ptr, int level, const char *fmt, ...)       

    # Get the logs.
    ctypedef void(*av_log_callback)(void *, int, const char *, va_list)
    void av_log_set_callback (av_log_callback callback)
