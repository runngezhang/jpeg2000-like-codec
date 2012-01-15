function demo_compress_block_ezw
img_in = '../images/circuit.bmp';
num_pass = 6;
M = 32;
postfix = sprintf('M%02d', M);
file_out = sprintf('../images/circuitBlockEZW%02d%s.dat', num_pass, postfix);
bpp_target = Inf;
if exist(file_out) == 0,
    compress_block_ezw(img_in, bpp_target, file_out, num_pass, M);
end
file_in = file_out;
img_out = sprintf('../images/circuitBlockEZW%02d%s.png', num_pass, postfix);
if exist(img_out) == 0,
    decompress_block_ezw(file_in, img_out);
end

plotdata_out = sprintf('../images/circuitBlockEZWPlot%02d%s.dat', num_pass, postfix);
if exist(plotdata_out) == 0,
    A = double(imgread(img_in));
    [nRow, nCol] = size(A);
    file_out = sprintf('../images/circuitBlockEZW%02d%s.dat', num_pass, postfix);
    file_in;
    eval(sprintf('load %s -mat', file_in));
    total_bits = 0;
    for i=1:num_pass
        bits = 0;
        %     for j=0:(floor(nCol/M)-1)
        %         sj = j*M+1;
        %         for k=0:(floor(nRow/M)-1)
        %             sk = k*M+1;
        %             bits = bits + (length(huffman_sigs{i}{k+1}{j+1}) + length(huffman_refs{i}{k+1}{j+1}));
        %         end
        %     end
        %     bits = 8 * bits;
        bits = 8 * (length(huffman_sigs{i}) + length(huffman_refs{i}));
        total_bits = total_bits + bits;
        bpp = total_bits / (nRow * nCol);
        bpps(i) = bpp;

        % Intermediate state X
        eval(sprintf('load %s.%02dof%02d -mat', file_in, i, num_pass)); % X
        % Inverse Wavelet
        addpath matlabPyrTools/
        addpath matlabPyrTools/MEX/
        I = blkproc(X, [M M], 'invwave_transform_qmf(x,P1)', 5);
        % add DC coponent
        for j=0:(floor(nCol/M)-1)
            sj = j*M+1;
            for k=0:(floor(nRow/M)-1)
                sk = k*M+1;
                I(sk:(sk+M-1), sj:(sj+M-1)) = I(sk:(sk+M-1), sj:(sj+M-1)) + dc{k+1}{j+1};
            end
        end

        psnrs(i) = psnr(A, I);

        I = uint8(I);
        img_out = sprintf('../images/circuitBlockEZW%02dof%02d%s.png', i, num_pass, postfix);
        imwrite(uint8(I), img_out);
    end
    eval(sprintf('save %s bpps psnrs -mat', plotdata_out));
else
    eval(sprintf('load %s -mat', plotdata_out));
end
bpps
psnrs
%figure;
hold on;
plot(bpps, psnrs, '-g');
title('BPP vs PSNR for Block-EZW Based Encoding');
xlabel('bpp (bits per pixel)');
ylabel('PSNR in dB');
