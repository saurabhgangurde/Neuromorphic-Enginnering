function [  ] = create_database(N)


    database=cell(1,N);
    for i=1:N
        image=create_image(1);
        rotated=imrotate(image,rand*360,'bilinear','crop');
        database{i}=rotated;
    end
    fprintf('creating database\n');
    save('./database/database.mat','database');
end

