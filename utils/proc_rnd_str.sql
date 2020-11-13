--- 与えられた長さのランダム文字列を返す、spは特殊文字も含む

--- EX SELECT rnd_str(3) -> ADW
--- EX SELECT rnd_str_sp(3) -> %


DROP FUNCTION IF EXISTS rnd_str;

delimiter //

CREATE FUNCTION rnd_str(len int) returns text
begin
  DECLARE cur int;
  DECLARE result text;
  SELECT 0 INTO cur;
  SET result = '';
  while cur < len do
    SET result = concat(result, substring('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ', ceil(rand()*36),1));
    SET cur = cur + 1;
  end while;
  return result;
end //

delimiter ;


DROP FUNCTION IF EXISTS rnd_str_sp;

delimiter //

CREATE FUNCTION rnd_str_sp(len int) returns text
begin
  DECLARE cur int;
  DECLARE result text;
  SELECT 0 INTO cur;
  SET result = '';
  while cur < len do
    SET result = concat(result, substring('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ()*/+<>?!"#$%&@[]', ceil(rand()*53),1));
    SET cur = cur + 1;
  end while;
  return result;
end //

delimiter ;
