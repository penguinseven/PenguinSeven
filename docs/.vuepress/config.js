module.exports = {
    base : '/',                             // 网站将在其部署的基本 URL
    title: '吧食笔记',                      // 网站的标题
    dest: 'dist',                    //指定 vuepress build 的输出目录
    description: 'PenguinSeven',        //网站描述
    head: [
        ['link', { rel: 'icon', href: '/logo.png' }]
    ],
    port : '8080',              //指定用于 dev 服务器的端口

    configureWebpack: {
        resolve: {
            alias: {
                '@alias': 'docs/public'
            }
        }
    },

    themeConfig: {
        nav: [
            { text: 'Home', link: '/' },
            { text: 'PHP', link: '/php/' },
            { text: 'External', link: 'https://google.com' },
        ],
        sidebar: {
            // 侧边栏在 /foo/ 上
            '/php/': [
                '',
                'laravel/',
                'yii/',
                'swoole/',
                'workerman/',
                'phpunit/',
                'hash/register',
                'libevent',
                'functions',
                'upcore',
                'error'
            ],
            // 侧边栏在 /bar/ 上
            '/bar/': [
                '',
                'three',
                'four'
            ]
        }
    },

}