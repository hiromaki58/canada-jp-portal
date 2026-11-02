import React from "react";
import { Link, useParams } from "react-router-dom";
import PublicLayout from "../../components/PublicLayout";
import { findJobById } from "../../data/sampleJobs";

// Public job detail page (/jobs/:id).
const JobDetailPage: React.FC = () => {
    const { id } = useParams();
    const job = findJobById(id);

    if (job === undefined) {
        return (
            <PublicLayout>
                <section className="pub-sec">
                    <div className="pub-sec-in pub-detail">
                        <h1 className="pub-detail-ttl">お仕事が見つかりませんでした</h1>
                        <p>掲載が終了したか、URL が正しくない可能性があります。</p>
                        <Link className="pub-btn pub-btn-outline" to="/">お仕事一覧へ戻る</Link>
                    </div>
                </section>
            </PublicLayout>
        );
    }

    return (
        <PublicLayout>
            <section className="pub-sec">
                <article className="pub-sec-in pub-detail">
                    <Link className="pub-back" to="/">← お仕事一覧へ戻る</Link>
                    <div className="pub-card-head">
                        <span className="pub-badge">{job.category}</span>
                        <span className="pub-badge pub-badge-outline">{job.employmentType}</span>
                    </div>
                    <h1 className="pub-detail-ttl">{job.title}</h1>
                    <p className="pub-card-company">{job.company}</p>

                    <dl className="pub-detail-table">
                        <div><dt>勤務地</dt><dd>{job.location}</dd></div>
                        <div><dt>雇用形態</dt><dd>{job.employmentType}</dd></div>
                        <div><dt>給与</dt><dd>{job.wage}</dd></div>
                        <div><dt>掲載日</dt><dd>{job.postedAt}</dd></div>
                    </dl>

                    <h2 className="pub-detail-h2">仕事内容</h2>
                    <p>{job.description}</p>

                    <h2 className="pub-detail-h2">応募条件</h2>
                    <ul className="pub-detail-list">
                        {job.requirements.map((item) => (
                            <li key={item}>{item}</li>
                        ))}
                    </ul>

                    <ul className="pub-tags">
                        {job.tags.map((tag) => (
                            <li key={tag}>#{tag}</li>
                        ))}
                    </ul>

                    <div className="pub-detail-apply">
                        <button type="button" className="pub-btn pub-btn-primary" disabled>
                            この求人に応募する
                        </button>
                        <p className="pub-cta-note">※ サンプル求人のため、応募は受け付けていません。</p>
                    </div>
                </article>
            </section>
        </PublicLayout>
    );
};

export default JobDetailPage;
