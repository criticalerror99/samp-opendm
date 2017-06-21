#define va_start<%0> (va_:(%0))

stock va_format(out[], size, fmat[], va_:STATIC_ARGS)
{
        new
                num_args,
                arg_start,
                arg_end;
        // Get the pointer to the number of arguments to the last function.
        #emit LOAD.S.pri   0
        #emit ADD.C        8
        #emit MOVE.alt
        // Get the number of arguments.
        #emit LOAD.I
        #emit STOR.S.pri   num_args
        // Get the variable arguments (end).
        #emit ADD
        #emit STOR.S.pri   arg_end
        // Get the variable arguments (start).
        #emit LOAD.S.pri   STATIC_ARGS
        #emit SMUL.C       4
        #emit ADD
        #emit STOR.S.pri   arg_start
        // Using an assembly loop here screwed the code up as the labels added some
        // odd stack/frame manipulation code...
        while (arg_end != arg_start)
        {
                #emit MOVE.pri
                #emit LOAD.I
                #emit PUSH.pri
                #emit CONST.pri    4
                #emit SUB.alt
                #emit STOR.S.pri   arg_end
        }
        // Push the additional parameters.
        #emit PUSH.S       fmat
        #emit PUSH.S       size
        #emit PUSH.S       out
        // Push the argument count.
        #emit LOAD.S.pri   num_args
        #emit ADD.C        12
        #emit LOAD.S.alt   STATIC_ARGS
        #emit XCHG
        #emit SMUL.C       4
        #emit SUB.alt
        #emit PUSH.pri
        #emit MOVE.alt
        // This gets confused if you have a local variable of the same name as it
        // seems to factor in them first, so you get the offset of the local
        // variable instead of the index of the native.
        #emit SYSREQ.C     format
        // Clear the stack.
        #emit CONST.pri    4
        #emit ADD
        #emit MOVE.alt
        // The three lines above get the total stack data size, now remove it.
        #emit LCTRL        4
        #emit ADD
        #emit SCTRL        4
        // Now do the real return.
}