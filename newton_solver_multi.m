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