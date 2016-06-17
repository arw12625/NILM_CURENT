


file = 'data/id26_down5.csv';

sig = loadSignal(file, {'"use"'}, 1, 1440);
[nsig, sigMag] = normalizeSig(sig);

[dic, dataNames] = createDictionary(file, 1, 1440, 10, {'"use"', '"gen"', '"grid"'}, true, 0);

...