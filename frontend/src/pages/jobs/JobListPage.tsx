import React, { useMemo } from "react";
import { Link, useSearchParams } from "react-router-dom";
import PublicLayout from "../../components/PublicLayout";
import {
    EMPLOYMENT_TYPES,
    JOB_CATEGORIES,
    JOB_LOCATIONS,
    Job,
    SAMPLE_JOBS,
} from "../../data/sampleJobs";

const KEYWORD_MAX_LENGTH = 50;

// Query parameters are untrusted: only values in the allowlist are used, anything else is ignored.
const pickAllowed = <T extends string>(value: string | null, allowed: readonly T[]): T | "" =>
    value !== null && (allowed as readonly string[]).includes(value) ? (value as T) : "";

const normalizeKeyword = (value: string | null): string => (value ?? "").trim().slice(0, KEYWORD_MAX_LENGTH);

const matchesKeyword = (job: Job, keyword: string): boolean => {
    if (keyword === "") {
        return true;
    }
    const needle = keyword.toLowerCase();
    return [job.title, job.company, job.summary, ...job.tags].some((text) => text.toLowerCase().includes(needle));
};

// Public top page (/): job board with keyword / category / location / employment type filters.
const JobListPage: React.FC = () => {
    const [searchParams, setSearchParams] = useSearchParams();
    const keyword = normalizeKeyword(searchParams.get("q"));
    const category = pickAllowed(searchParams.get("category"), JOB_CATEGORIES);
    const location = pickAllowed(searchParams.get("location"), JOB_LOCATIONS);
    const employmentType = pickAllowed(searchParams.get("type"), EMPLOYMENT_TYPES);

    const jobs = useMemo(
        () =>
            SAMPLE_JOBS.filter(
                (job) =>
                    matchesKeyword(job, keyword) &&
                    (category === "" || job.category === category) &&
                    (location === "" || job.location === location) &&
                    (employmentType === "" || job.employmentType === employmentType)
            ).sort((a, b) => b.postedAt.localeCompare(a.postedAt)),
        [keyword, category, location, employmentType]
    );

    const updateParam = (name: string, value: string) => {
        const next = new URLSearchParams(searchParams);
        if (value === "") {
            next.delete(name);
        } else {
            next.set(name, value);
        }
        setSearchParams(next, { replace: true });
    };

    const handleSearch = (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        const form = new FormData(event.currentTarget);
        updateParam("q", normalizeKeyword(form.get("q") as string | null));
    };

    const hasFilter = keyword !== "" || category !== "" || location !== "" || employmentType !== "";

    return (
        <PublicLayout>
            <section className="pub-hero">
                <div className="pub-hero-in">
                    <p className="pub-hero-en">Find your job in Canada</p>
                    <h1 className="pub-hero-ttl">カナダで、日本語を活かして働こう。</h1>
                    <p className="pub-hero-lead">
                        ワーキングホリデーから正社員まで。カナダ各地の日本語を活かせるお仕事を掲載しています。
                    </p>
                    <form className="pub-search" role="search" onSubmit={handleSearch}>
                        <label className="hidden" htmlFor="job-keyword">キーワード</label>
                        <input
                            id="job-keyword"
                            key={keyword}
                            name="q"
                            type="search"
                            defaultValue={keyword}
                            maxLength={KEYWORD_MAX_LENGTH}
                            placeholder="職種・会社名・キーワード"
                        />
                        <button type="submit" className="pub-btn pub-btn-primary">検索する</button>
                    </form>
                </div>
            </section>

            <section className="pub-sec" id="jobs" aria-labelledby="jobs-ttl">
                <div className="pub-sec-in">
                    <div className="pub-sec-head">
                        <p className="pub-sec-en">Jobs</p>
                        <h2 className="pub-sec-ttl" id="jobs-ttl">お仕事を探す</h2>
                    </div>

                    <div className="pub-chips" role="group" aria-label="職種で絞り込む">
                        <button
                            type="button"
                            className={`pub-chip${category === "" ? " is-active" : ""}`}
                            aria-pressed={category === ""}
                            onClick={() => updateParam("category", "")}
                        >
                            すべて
                        </button>
                        {JOB_CATEGORIES.map((item) => (
                            <button
                                key={item}
                                type="button"
                                className={`pub-chip${category === item ? " is-active" : ""}`}
                                aria-pressed={category === item}
                                onClick={() => updateParam("category", item)}
                            >
                                {item}
                            </button>
                        ))}
                    </div>

                    <div className="pub-filters">
                        <label className="pub-select">
                            <span>勤務地</span>
                            <select value={location} onChange={(e) => updateParam("location", e.target.value)}>
                                <option value="">すべて</option>
                                {JOB_LOCATIONS.map((item) => (
                                    <option key={item} value={item}>{item}</option>
                                ))}
                            </select>
                        </label>
                        <label className="pub-select">
                            <span>雇用形態</span>
                            <select value={employmentType} onChange={(e) => updateParam("type", e.target.value)}>
                                <option value="">すべて</option>
                                {EMPLOYMENT_TYPES.map((item) => (
                                    <option key={item} value={item}>{item}</option>
                                ))}
                            </select>
                        </label>
                        <p className="pub-count" aria-live="polite">
                            <strong>{jobs.length}</strong> 件のお仕事
                        </p>
                        {hasFilter && (
                            <button type="button" className="pub-link-btn" onClick={() => setSearchParams({}, { replace: true })}>
                                条件をクリア
                            </button>
                        )}
                    </div>

                    {jobs.length === 0 ? (
                        <p className="pub-empty">条件に合うお仕事が見つかりませんでした。条件を変えて検索してください。</p>
                    ) : (
                        <ul className="pub-cards">
                            {jobs.map((job) => (
                                <li key={job.id} className="pub-card">
                                    <Link to={`/jobs/${job.id}`} className="pub-card-link">
                                        <div className="pub-card-head">
                                            <span className="pub-badge">{job.category}</span>
                                            <span className="pub-badge pub-badge-outline">{job.employmentType}</span>
                                        </div>
                                        <h3 className="pub-card-ttl">{job.title}</h3>
                                        <p className="pub-card-company">{job.company}</p>
                                        <p className="pub-card-summary">{job.summary}</p>
                                        <dl className="pub-card-meta">
                                            <div><dt>勤務地</dt><dd>{job.location}</dd></div>
                                            <div><dt>給与</dt><dd>{job.wage}</dd></div>
                                        </dl>
                                        <ul className="pub-tags">
                                            {job.tags.map((tag) => (
                                                <li key={tag}>#{tag}</li>
                                            ))}
                                        </ul>
                                        <span className="pub-card-more">詳細を見る</span>
                                    </Link>
                                </li>
                            ))}
                        </ul>
                    )}
                </div>
            </section>

            <section className="pub-sec pub-sec-tint" id="about" aria-labelledby="about-ttl">
                <div className="pub-sec-in">
                    <div className="pub-sec-head">
                        <p className="pub-sec-en">About</p>
                        <h2 className="pub-sec-ttl" id="about-ttl">Canada JP Portal について</h2>
                    </div>
                    <ul className="pub-features">
                        <li>
                            <h3>日本語を活かせる求人</h3>
                            <p>日本語スキルが評価されるお仕事を中心に掲載しています。</p>
                        </li>
                        <li>
                            <h3>ワーホリから正社員まで</h3>
                            <p>滞在スタイルに合わせて、雇用形態から探せます。</p>
                        </li>
                        <li>
                            <h3>カナダ全土をカバー</h3>
                            <p>バンクーバー、トロント、モントリオールなど主要都市の求人を紹介します。</p>
                        </li>
                    </ul>
                </div>
            </section>

            <section className="pub-cta" id="contact" aria-labelledby="contact-ttl">
                <div className="pub-cta-in">
                    <h2 className="pub-cta-ttl" id="contact-ttl">求人掲載をご検討の企業様へ</h2>
                    <p>日本語人材の採用について、お気軽にご相談ください。</p>
                    <p className="pub-cta-note">※ 現在はステージング環境のため、掲載中の求人はすべてサンプルです。</p>
                </div>
            </section>
        </PublicLayout>
    );
};

export default JobListPage;
