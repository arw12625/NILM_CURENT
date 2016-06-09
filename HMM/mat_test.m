states = 2;
init = [.5, .5];
output = [1,2,1,2,1,1];
transition = [.1,.9;.2,.8];
emission = [.6,.4;.5,.5];

viterbi(states, init, output, transition, emission)
