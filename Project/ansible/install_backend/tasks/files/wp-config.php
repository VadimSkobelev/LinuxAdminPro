<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wp' );

/** Database password */
define( 'DB_PASSWORD', '!OtusLinux2024' );

/** Database hostname */
define( 'DB_HOST', '10.10.60.10' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '<E2&!d6i{bTKmOUg XpNnoGtriO)9(MmP{?+A h,$|8Z{][15<$4{6TvGZUPLZIH' );
define( 'SECURE_AUTH_KEY',  '~kkNptasTz08!%b/hz[)O[ prGA{%=Le;Evy$UNQ~St_eXl*Th3*O|HKi.P}C+M2' );
define( 'LOGGED_IN_KEY',    'd;>/$-cA-e<DA%3L7%L+[fM (QZ<v-qPcvD`^MP8:#g/}qOFNYO:4tv)5d0hMX?t' );
define( 'NONCE_KEY',        '%V*g6ETx`x+Bf{11R]AJ:FW^HXl}JZLP_6WUbA<:/84-zYAGd=B0+2-)VgTL8Ht(' );
define( 'AUTH_SALT',        ':3`d5|i+lHm}L%`<*wu+bK4#o|sPR:NL=MuY>vnXcpA?rJx9iqP&i?vI1MM(S7uU' );
define( 'SECURE_AUTH_SALT', 'i&z~gm?J,uiE2Vi%@Sn4;VRAeXT%.ZwpfRH}!=[!U`3.pqcDYqV5kp)q<(NH|A;f' );
define( 'LOGGED_IN_SALT',   'b<VR-zuh]sAUwe<%rAhG@aK$1i/ ~C9]HT]9smw9FkEU!,EURb-2HNcb9}>`6:iW' );
define( 'NONCE_SALT',       '!UI}W7=YcfVN#j/$n8TNCjz7U<K1G_T$Bw.%!e-83NJ0s~Ne+J%2uAP^2v6cq,4N' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';