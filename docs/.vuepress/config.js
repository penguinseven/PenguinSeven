module.exports = {
    title: 'PenguinSeven',
    description: '吧食笔记',
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
                'hash/register',
                'libevent',
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
    }
}