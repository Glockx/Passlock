//
//  DD.c
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/29.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

#include "DD.h"
#include <stdio.h>
#include <stdlib.h>

/// PT_DENY_ATTACH is an Apple-specific constant that can prevent debuggers (gdb, DTrace, etc.) from debugging your binary in kernel-level. Calling ptrace(PT_DENY_ATTACH, 0, 0, 0) will send a SEGFAULT to its tracing parent. But this method not working with dynamic runtime dependency inject libraries such as: Frida. So additional library and port checking added for preventing such libraries.
// https://iphonedevwiki.net/index.php/Crack_prevention#PT_DENY_ATTACH
void dd()
{
    asm volatile (
        "mov x0, #26\n"     // set #define PT_DENY_ATTACH (31) to r0
        "mov x1, #31\n"     // clear r1
        "mov x2, #0\n"      // clear r2
        "mov x3, #0\n"      // clear r3
        "mov x16, #0\n"     // set the instruction pointer to syscal 26
        "svc #128\n"        // SVC (formerly SWI) generates a supervisor call. Supervisor calls are normally used to request privileged operations or access to system resources from an operating system.
        );
    exit(0);
}
