classdef MatGA < handle

    properties
        populationSize = 500;
        maxGen = 500;
        childPct = .2;
        mutationPct = .1;
        numSamples = 0;
        numFeatures = 0;
        fitness;
        fittest;
        initRange = [-.1 .1];
        X;
        Y;
        A;       
    end
    
    methods
        % CONSTRUCTOR
        function M = MatGA(popSize,gen,childP,mutP,range)
            if nargin == 5
                M.populationSize = popSize;
                M.maxGen = gen;
                M.childPct = childP;
                M.mutationPct = mutP;
                if isequal(size(range),[1 2]) && range(1) < range(2)
                    M.initRange = range;
                else
                    error('Invalid intial range');
                end
            elseif nargin == 0
            else
                error('Invalid number of inputs');
            end
        end
        
        function addData(self,inputs,outputs)
            if size(inputs,1) == size(outputs,1)
                self.X = inputs;
                self.Y = outputs;               
                self.numSamples = size(inputs,1);
                self.numFeatures = size(inputs,2);
            else
                error('Inputs and outputs have incompatable dimensions');
            end
        end
        
        function fitData(self)
            inputs = self.X;
            targets = self.Y;
            h = @(x) fitFunc(x,inputs,targets);
            
            eliteAmount = (1 - self.childPct)*self.populationSize;
            ga_opts = gaoptimset('display','iter','generations',self.maxGen,'TolFun',0,'PopInitRange',self.initRange','PopulationSize',self.populationSize,'EliteCount',eliteAmount,'CrossoverFraction',1-self.mutationPct);
            [self.A, self.fitness] = ga(h, self.numFeatures+1, ga_opts);
            self.A = self.A';
        end
        
        function outputs = predict(self,inputs)
            outputs = (inputs * self.A(2:end)) + self.A(1);
        end
    end
end