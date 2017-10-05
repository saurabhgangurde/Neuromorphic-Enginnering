function [  ] = create_database(N)


    database=cell(1,N);
    for i=1:N
        image=create_image(1);
        rotate=mod(i,4)*45;
        angle=normrnd(rotate,8);
        rotated=imrotate(image,angle,'bilinear','crop');
        database{i}=rotated;
    end
    fprintf('creating database\n');
    save('./database/database.mat','database');
end

