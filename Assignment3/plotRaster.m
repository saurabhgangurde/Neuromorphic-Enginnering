function [] = plotRaster(spikeMat, tVec)
    figure();
    hold all;
    for trialCount = 1:size(spikeMat,1)
        index=find(spikeMat(trialCount, :)==1);
        spikePos = tVec(index);
        for spikeCount = 1:length(spikePos)
            plot([spikePos(spikeCount) spikePos(spikeCount)], ...
                [trialCount-0.4 trialCount+0.4], 'k');
        end
    end
    ylim([0 size(spikeMat, 1)+1]);
    title('Raster Plot');xlabel('Time in s');ylabel('Neurons');
    hold off;
end