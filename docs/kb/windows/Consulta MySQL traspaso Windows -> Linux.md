#Consulta MySQL traspaso Windows -> Linux

No se por qué, al recuperar bases de datos mysql que han pasado por servidores Windows en servidores linux, me ha pasado un par de veces que, los textos de las entradas en WordPress no cogen bien los acentos, los signos de interrogación, admiración etc.

Esta consulta puede ser util (manejar con cuidado y hacer un backup antes) :

```SQL
    update `wp_posts` set `post_content` = replace(`post_content` ,'Ã¡','á');
    update `wp_posts` set `post_content` = replace(`post_content` ,'Ã©','é');
    update `wp_posts` set `post_content` = replace(`post_content` ,'í©','é');
    update `wp_posts` set `post_content` = replace(`post_content` ,'Ã³','ó');
    update `wp_posts` set `post_content` = replace(`post_content` ,'íº','ú');
    update `wp_posts` set `post_content` = replace(`post_content` ,'Ãº','ú');
    update `wp_posts` set `post_content` = replace(`post_content` ,'Ã±','ñ');
    update `wp_posts` set `post_content` = replace(`post_content` ,'í‘','Ñ');
    update `wp_posts` set `post_content` = replace(`post_content` ,'Ã','í');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€“','–');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€”','–');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€™','\'');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€¦','...');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€“','-');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€œ','"');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€','"');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€˜','\'');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€¢','-');
    update `wp_posts` set `post_content` = replace(`post_content` ,'â€¡','c');
    update `wp_posts` set `post_content` = replace(`post_content` ,'Â','');
     
    update `wp_posts` set `post_title` = replace(`post_title` ,'Ã¡','á');
    update `wp_posts` set `post_title` = replace(`post_title` ,'Ã©','é');
    update `wp_posts` set `post_title` = replace(`post_title` ,'í©','é');
    update `wp_posts` set `post_title` = replace(`post_title` ,'Ã³','ó');
    update `wp_posts` set `post_title` = replace(`post_title` ,'íº','ú');
    update `wp_posts` set `post_title` = replace(`post_title` ,'Ãº','ú');
    update `wp_posts` set `post_title` = replace(`post_title` ,'Ã±','ñ');
    update `wp_posts` set `post_title` = replace(`post_title` ,'í‘','Ñ');
    update `wp_posts` set `post_title` = replace(`post_title` ,'Ã','í');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€“','–');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€”','–');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€™','\'');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€¦','...');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€“','-');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€œ','"');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€','"');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€˜','\'');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€¢','-');
    update `wp_posts` set `post_title` = replace(`post_title` ,'â€¡','c');
    update `wp_posts` set `post_title` = replace(`post_title` ,'Â','');
     
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Ã¡','á');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Ã©','é');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'í©','é');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Ã³','ó');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'íº','ú');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Ãº','ú');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Ã±','ñ');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'í‘','Ñ');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Ã','í');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€“','–');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€”','–');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€™','\'');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€¦','...');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€“','-');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€œ','"');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€','"');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€˜','\'');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€¢','-');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'â€¡','c');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'Â','');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'í‰','É');
    update `wp_postmeta` set `meta_value` = replace(`meta_value` ,'í“','Ó');
     
    update `wp_options` set `option_value` = replace(`option_value` ,'Ã¡','á');
    update `wp_options` set `option_value` = replace(`option_value` ,'Ã©','é');
    update `wp_options` set `option_value` = replace(`option_value` ,'í©','é');
    update `wp_options` set `option_value` = replace(`option_value` ,'Ã³','ó');
    update `wp_options` set `option_value` = replace(`option_value` ,'íº','ú');
    update `wp_options` set `option_value` = replace(`option_value` ,'Ãº','ú');
    update `wp_options` set `option_value` = replace(`option_value` ,'Ã±','ñ');
    update `wp_options` set `option_value` = replace(`option_value` ,'í‘','Ñ');
    update `wp_options` set `option_value` = replace(`option_value` ,'Ã','í');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€“','–');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€”','–');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€™','\'');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€¦','...');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€“','-');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€œ','"');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€','"');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€˜','\'');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€¢','-');
    update `wp_options` set `option_value` = replace(`option_value` ,'â€¡','c');
    update `wp_options` set `option_value` = replace(`option_value` ,'Â','');
    update `wp_options` set `option_value` = replace(`option_value` ,'í‰','É');
    update `wp_options` set `option_value` = replace(`option_value` ,'í“','Ó')
```
