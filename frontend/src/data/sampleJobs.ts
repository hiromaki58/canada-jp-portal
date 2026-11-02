// Sample job postings for the staging environment.
// Static data only: replace with an API call once job postings are managed from the admin area.

export const JOB_CATEGORIES = ["飲食・サービス", "IT・エンジニア", "オフィスワーク", "観光・ホテル", "教育・保育"] as const;
export const JOB_LOCATIONS = ["Vancouver", "Toronto", "Montreal", "Calgary", "リモート"] as const;
export const EMPLOYMENT_TYPES = ["正社員", "契約社員", "アルバイト・パート", "ワーホリ可"] as const;

export type JobCategory = (typeof JOB_CATEGORIES)[number];
export type JobLocation = (typeof JOB_LOCATIONS)[number];
export type EmploymentType = (typeof EMPLOYMENT_TYPES)[number];

export type Job = {
    id: string;
    title: string;
    company: string;
    category: JobCategory;
    location: JobLocation;
    employmentType: EmploymentType;
    wage: string;
    summary: string;
    description: string;
    requirements: string[];
    tags: string[];
    postedAt: string; // YYYY-MM-DD
};

export const SAMPLE_JOBS: readonly Job[] = [
    {
        id: "1001",
        title: "日本食レストランのホールスタッフ",
        company: "Sakura Dining Vancouver",
        category: "飲食・サービス",
        location: "Vancouver",
        employmentType: "ワーホリ可",
        wage: "CAD 17.85〜 / 時 + チップ",
        summary: "ダウンタウンの人気和食店で接客スタッフを募集。未経験でも丁寧にトレーニングします。",
        description:
            "ご来店されるお客様のご案内、オーダー受け、配膳、レジ対応をお願いします。英語での接客が中心ですが、日本人スタッフも多く在籍しているので安心して働けます。",
        requirements: ["日常会話レベルの英語", "週3日以上勤務できる方", "Food Safe 資格（入社後取得も可）"],
        tags: ["未経験歓迎", "まかない付き", "シフト制"],
        postedAt: "2026-10-28",
    },
    {
        id: "1002",
        title: "フロントエンドエンジニア（React / TypeScript）",
        company: "Maple Tech Solutions",
        category: "IT・エンジニア",
        location: "Toronto",
        employmentType: "正社員",
        wage: "CAD 85,000〜110,000 / 年",
        summary: "日加両市場向け SaaS のフロントエンド開発。ビザサポートあり。",
        description:
            "React と TypeScript を用いた Web アプリケーションの設計・実装を担当していただきます。日本のクライアント向け機能も多く、日本語と英語の両方を活かせるポジションです。",
        requirements: ["React での実務経験 2 年以上", "TypeScript の実務経験", "ビジネスレベルの英語"],
        tags: ["ビザサポート", "ハイブリッド勤務", "日本語を活かせる"],
        postedAt: "2026-10-30",
    },
    {
        id: "1003",
        title: "日系商社の営業アシスタント",
        company: "North Bridge Trading",
        category: "オフィスワーク",
        location: "Vancouver",
        employmentType: "契約社員",
        wage: "CAD 24〜28 / 時",
        summary: "日本からの輸入品を扱う商社で、受発注管理と営業サポートを担当。",
        description:
            "日本の取引先とのメール・電話対応、受発注データの入力、請求書作成などをお願いします。Excel を使った定型業務が中心です。",
        requirements: ["ビジネスレベルの日本語", "Excel の基本操作", "日常会話以上の英語"],
        tags: ["土日休み", "残業少なめ"],
        postedAt: "2026-10-25",
    },
    {
        id: "1004",
        title: "ホテルのゲストサービス（日本語対応）",
        company: "Rocky Mountain Resort",
        category: "観光・ホテル",
        location: "Calgary",
        employmentType: "ワーホリ可",
        wage: "CAD 18.50〜 / 時",
        summary: "バンフ近郊のリゾートホテルで日本人ゲストのサポートを担当。寮あり。",
        description:
            "フロントでのチェックイン・チェックアウト対応、観光案内、日本からの団体ツアーのサポートを担当していただきます。",
        requirements: ["日常会話レベルの英語", "接客経験のある方歓迎", "6 か月以上勤務できる方"],
        tags: ["寮あり", "日本語を活かせる", "未経験歓迎"],
        postedAt: "2026-10-20",
    },
    {
        id: "1005",
        title: "日本語補習校の講師",
        company: "Toronto Japanese Saturday School",
        category: "教育・保育",
        location: "Toronto",
        employmentType: "アルバイト・パート",
        wage: "CAD 25〜 / 時",
        summary: "土曜日の午前中に小学生へ国語・算数を教えるお仕事です。",
        description:
            "日本の学習指導要領に沿って、小学生の国語・算数の授業を担当していただきます。教材は学校で用意しています。",
        requirements: ["ネイティブレベルの日本語", "教員免許または指導経験のある方歓迎", "毎週土曜日に勤務できる方"],
        tags: ["土曜のみ", "週1日から"],
        postedAt: "2026-10-18",
    },
    {
        id: "1006",
        title: "カスタマーサポート（日本語・英語）",
        company: "Aurora Payments",
        category: "オフィスワーク",
        location: "リモート",
        employmentType: "正社員",
        wage: "CAD 55,000〜65,000 / 年",
        summary: "決済サービスを利用する日本のお客様からの問い合わせにメールとチャットで対応。",
        description:
            "日本語でのお問い合わせ対応と、社内の英語チームへのエスカレーションを担当していただきます。カナダ国内からのフルリモート勤務です。",
        requirements: ["ネイティブレベルの日本語", "ビジネスレベルの英語", "カナダでの就労資格"],
        tags: ["フルリモート", "日本語を活かせる"],
        postedAt: "2026-10-31",
    },
    {
        id: "1007",
        title: "寿司カウンターの調理スタッフ",
        company: "Umi Sushi Montreal",
        category: "飲食・サービス",
        location: "Montreal",
        employmentType: "正社員",
        wage: "CAD 20〜26 / 時",
        summary: "寿司職人として経験を活かせるポジション。LMIA サポートの相談可。",
        description:
            "寿司・刺身の仕込みと提供、仕入れ管理を担当していただきます。将来的には料理長候補としてのキャリアも目指せます。",
        requirements: ["寿司調理の経験 2 年以上", "フランス語は不問", "チームで働くことが好きな方"],
        tags: ["ビザサポート", "経験者優遇"],
        postedAt: "2026-10-15",
    },
    {
        id: "1008",
        title: "QA エンジニア（テスト自動化）",
        company: "Polar Games Studio",
        category: "IT・エンジニア",
        location: "Montreal",
        employmentType: "契約社員",
        wage: "CAD 35〜45 / 時",
        summary: "日本向けゲームのローカライズ品質チェックとテスト自動化を担当。",
        description:
            "日本語版ゲームのテスト計画の作成、不具合報告、テストの自動化を担当していただきます。日本語の表現チェックも重要な業務です。",
        requirements: ["ソフトウェアテストの実務経験", "ネイティブレベルの日本語", "日常会話以上の英語"],
        tags: ["日本語を活かせる", "ハイブリッド勤務"],
        postedAt: "2026-10-22",
    },
];

export const findJobById = (id: string | undefined): Job | undefined =>
    id === undefined ? undefined : SAMPLE_JOBS.find((job) => job.id === id);
