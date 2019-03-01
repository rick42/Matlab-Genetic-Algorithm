function fitness = fitFunc(chromosome, inputs, targets)    
    constTemp = chromosome(1);
    ATemp = chromosome(2:end)';

    yHat = (inputs * ATemp) + constTemp;

    sum = 0;
    numSamples = length(targets);
    for i = 1:numSamples
        fraction = ((targets(i)-yHat(i))/targets(i))^2;
        sum = sum + fraction;
    end
    fitness = sqrt(sum)/numSamples;
end