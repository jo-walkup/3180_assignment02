[f, J] = test_function01([1, 2, 3])

newton_solver_multi(@test_function01, [1, 2, 3])

%the function name and input/output variable names
%are just what I chose, you can use whatever names you'd like
function [f_val,J] = test_function01(X)
    X(1);
    X(2);
    X(3);

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


function [Xn, x_list] = newton_solver_multi(fun,X0)

    Xn = X0;
    x_list = [];

    max_iter = 100;

    for i = 1:max_iter

        [F, J] = fun(Xn);

        if abs(F) < 0.00000000000000005
            return
        end

        xn1 = Xn - J\F;
        x_list = [x_list, Xn];
        sub = subs(xn1, [F(1), F(2), F(3)]);
        doubles = double(sub);

        if abs(xn1-Xn) < 1e-14 && abs(F) < 1e-14
            Xn = xn1;
            return
        end

        if abs(xn1-Xn) > 1e6
            return
        end

        Xn = xn1;

    end

end