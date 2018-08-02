function bstop = showJ_history(x, optv, state)
    plot(optv.iter, optv.fval, 'x')
    # setting bstop to true stops optimization
    bstop = false;
endfunction
