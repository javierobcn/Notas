
## Exim + Ipv6 + Gmail


Nos comunica un cliente que los mensajes le vienen devueltos con este mensaje:

    This message was created automatically by mail delivery software.
      
    A message that you sent could not be delivered to one or more of its
    recipients. This is a permanent error. The following address(es) failed:
      
      perez******@gmail.com
        SMTP error from remote mail server after end of data:
        host gmail-smtp-in.l.google.com [2a00:1450:400c:c06::1a]:
        550-5.7.1 [2001:41d0:52:400::a67] Our system has detected that this message does
        550-5.7.1 not meet IPv6 sending guidelines regarding PTR records and
        550-5.7.1 authentication. Please review
        550-5.7.1  https://support.google.com/mail/?p=ipv6_authentication_error for more
        550 5.7.1 information. a125si20128233wmf.3 - gsmtp
      
    ------ This is a copy of the message, including all the headers. ------
    
    
Lo que hago es desactivar el IPV6 en el exim:
    
    nano /etc/exim4/exim4.conf.template

y agrego la linea

    SPAMASSASSIN = yes
    SPAM_SCORE = 50
    CLAMD =  yes
     
    disable_ipv6 = true 
     
    domainlist local_domains = dsearch;/etc/exim4/domains/