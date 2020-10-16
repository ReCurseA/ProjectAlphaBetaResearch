function quantized = quantization(toQuant, period)
partition = -100:period:100;
codebook = [partition 100+period];
[index, quantized] = quantiz(toQuant, partition, codebook);
end