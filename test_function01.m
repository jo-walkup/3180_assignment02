function [f_val,J_val] = test_function01(X)
    % X(1);
    % X(2);
    % X(3);

    syms x1 x2 x3

    f1 = x1^2 + x2^2 - 6 - x3^5;
    f2 = x1*x3 +x2 - 12;
    f3 = sin(x1 + x2 + x3);
    f = [f1; f2; f3];

    f_subs = subs(f, [x1, x2, x3], [X(1), X(2), X(3)]);
    f_val = double(f_subs);

    df1_dx1 = diff(f1, x1);
    df1_dx2 = diff(f1, x2);
    df1_dx3 = diff(f1, x3);
    df2_dx1 = diff(f2, x1);
    df2_dx2 = diff(f2, x2);
    df2_dx3 = diff(f2, x3);
    df3_dx1 = diff(f3, x1);
    df3_dx2 = diff(f3, x2);
    df3_dx3 = diff(f3, x3);

    J = [df1_dx1, df1_dx2, df1_dx3; df2_dx1, df2_dx2, df2_dx3; df3_dx1, df3_dx2, df3_dx3];
    J_subs = subs(J, [x1, x2, x3], [X(1), X(2), X(3)]);
    J_val = double(J_subs);
end