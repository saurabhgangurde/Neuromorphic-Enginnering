function [ output_args ] = Construct_network()

    number_of_neurons=32*32+4;
    Fanout=cell(number_of_neurons,1);
    for i=1:number_of_neurons
            Fanout{i}=[1 2 3 4];

        

end

