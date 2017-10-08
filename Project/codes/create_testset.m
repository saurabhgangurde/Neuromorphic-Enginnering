function [  ] = create_testset(N)


    test_set=cell(1,N);
    for i=1:N
        image=create_image(1);
        rotate=mod(i,4)*45;
        angle=normrnd(rotate,8);
        rotated=imrotate(image,angle,'bilinear','crop');
        test_set{i,1}=rotated;
        test_set{i,2}=mod(i,4);
    end
    
    save('./database/test_set.mat','test_set');
end

