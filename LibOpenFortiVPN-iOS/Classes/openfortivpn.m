//
//  openfortivpn.m
//  openfortivpn
//
//  Created by Henry Kim on 2021/06/05.
//

#import "openfortivpn.h"
#include "config.h"
#include "tunnel.h"
#include "userinput.h"
#include "log.h"

#include <openssl/ssl.h>

#include <unistd.h>
#include <getopt.h>

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REVISION "1"
#define VERSION "0.0.1"

@implementation openfortivpn

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self running];
    }
    return self;
}

- (void)running {
    int ret = EXIT_FAILURE;
    
    struct vpn_config cfg = {
        .gateway_host = {"222.235.208.254"},
        .gateway_port = 10443,
        .username = {"neoroman"},
        .password = {"dbdpswpf12#$"},
        .password_set = 1,
        .otp = {'\0'},
        .otp_prompt = NULL,
        .otp_delay = 0,
        .no_ftm_push = 0,
        .pinentry = NULL,
        .realm = {'\0'},
        .iface_name = {'\0'},
        .set_routes = 1,
        .set_dns = 1,
        .use_syslog = 0,
        .half_internet_routes = 0,
        .persistent = 0,
#if HAVE_RESOLVCONF
        .use_resolvconf = USE_RESOLVCONF,
#endif
#if HAVE_USR_SBIN_PPPD
        .pppd_use_peerdns = 0,
        .pppd_log = NULL,
        .pppd_plugin = NULL,
        .pppd_ipparam = NULL,
        .pppd_ifname = NULL,
        .pppd_call = NULL,
#endif
#if HAVE_USR_SBIN_PPP
        .ppp_system = NULL,
#endif
        .ca_file = NULL,
        .user_cert = NULL,
        .user_key = NULL,
        .pem_passphrase = {'\0'},
        .pem_passphrase_set = 0,
        .insecure_ssl = 0,
#ifdef TLS1_2_VERSION
        .min_tls = TLS1_2_VERSION,
#else
        .min_tls = 0,
#endif
        .seclevel_1 = 0,
        .cipher_list = NULL,
        .cert_whitelist = NULL,
        .use_engine = 0,
        .user_agent = NULL,
    };
    struct vpn_config cli_cfg = invalid_cfg;
        
    init_logging();
    
    log_debug("openfortivpn " VERSION "\n");
    if (strcmp(&REVISION[1], VERSION))
        log_debug("revision " REVISION "\n");
    
    // Load configuration file
    /*
    cli_cfg.username = strdup("neoroman")
    cli_cfg.gateway_host = strdup("222.235.208.254")
    cli_cfg.gateway_port = 10443
     */
    
    // Then apply CLI configuration
    merge_config(&cfg, &cli_cfg);
    set_syslog(cfg.use_syslog);
    
    // Set default UA
    if (cfg.user_agent == NULL)
        cfg.user_agent = strdup("Mozilla/5.0 SV1");
        
    // Check host and port
    if (cfg.gateway_host[0] == '\0' || cfg.gateway_port == 0) {
        log_error("Specify a valid host:port couple.\n");
        goto user_error;
    }
    // Check username
    if (cfg.username[0] == '\0')
        // Need either username or cert
        if (cfg.user_cert == NULL) {
            log_error("Specify a username.\n");
            goto user_error;
        }
    // If username but no password given, interactively ask user
    if (!cfg.password_set && cfg.username[0] != '\0') {
        char hint[USERNAME_SIZE + 1 + REALM_SIZE + 1 + GATEWAY_HOST_SIZE + 10];
        
        sprintf(hint, "%s_%s_%s_password",
                cfg.username, cfg.realm, cfg.gateway_host);
        read_password(cfg.pinentry, hint,
                      "VPN account password: ",
                      cfg.password, PASSWORD_SIZE);
    }
    log_debug("Configuration host = \"%s\"\n", cfg.gateway_host);
    log_debug("Configuration realm = \"%s\"\n", cfg.realm);
    log_debug("Configuration port = \"%d\"\n", cfg.gateway_port);
    if (cfg.username[0] != '\0')
        log_debug("Configuration username = \"%s\"\n", cfg.username);
    log_debug_all("Configuration password = \"%s\"\n", cfg.password);
    if (cfg.otp[0] != '\0')
        log_debug("One-time password = \"%s\"\n", cfg.otp);
    
    if (geteuid() != 0) {
        log_error("This process was not spawned with root privileges, which are required.\n");
        ret = EXIT_FAILURE;
        goto exit;
    }
    
    do {
        if (run_tunnel(&cfg) != 0)
            ret = EXIT_FAILURE;
        else
            ret = EXIT_SUCCESS;
        if ((cfg.persistent > 0) && (get_sig_received() == 0))
            sleep(cfg.persistent);
    } while ((get_sig_received() == 0) && (cfg.persistent != 0));
    
    goto exit;
    
user_error:
    fprintf(stderr, "openfortivpn error...!");
exit:
    destroy_vpn_config(&cfg);
    exit(ret);
}

@end
