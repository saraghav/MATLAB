% laddeR netwoRk

syms R1 R2 R3 R4 R5 R6 R7 R8 R9;

Rc = R7 + R8 + R9;
Rc_p = R6 * Rc / (R6 + Rc);
Rb = R4 + Rc_p + R5;
Rb_p = R3 * Rb / (R3 + Rb);
Ra = R1 + Rb_p + R2;

v1 = 1 * Rb_p / (R1 + Rb_p + R2);
v2 = v1 * Rc_p / (R4 + Rc_p + R5);
vout = v2 * R9 / (R7 + R8 + R9);

values = [90 110];

result = [];

for r1 = values
    for r2 = values
        for r3 = values
            for r4 = values
                for r5 = values
                    for r6 = values
                        for r7 = values
                            for r8 = values
                                for r9 = values
                                    val = subs(vout, [R1,R2,R3,R4,R5,R6,R7,R8,R9], [r1,r2,r3,r4,r5,r6,r7,r8,r9]);
                                    result = [result; r1 r2 r3 r4 r5 r6 r7 r8 r9 val];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end