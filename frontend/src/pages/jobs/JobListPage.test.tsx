import React from "react";
import { fireEvent, render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";
import JobListPage from "./JobListPage";
import { SAMPLE_JOBS } from "../../data/sampleJobs";

const renderAt = (url = "/") =>
    render(
        <MemoryRouter initialEntries={[url]}>
            <JobListPage />
        </MemoryRouter>
    );

const jobHeadings = () => screen.queryAllByRole("heading", { level: 3 }).filter((h) => h.className === "pub-card-ttl");

describe("JobListPage", () => {
    test("lists all sample jobs with links to the detail page", () => {
        renderAt();

        expect(screen.getByRole("heading", { level: 1 })).toBeInTheDocument();
        expect(jobHeadings()).toHaveLength(SAMPLE_JOBS.length);
        const link = screen.getByRole("link", { name: /フロントエンドエンジニア/ });
        expect(link).toHaveAttribute("href", "/jobs/1002");
    });

    test("filters by keyword", () => {
        renderAt();

        fireEvent.change(screen.getByLabelText("キーワード"), { target: { value: "React" } });
        fireEvent.click(screen.getByRole("button", { name: "検索する" }));

        expect(jobHeadings().map((h) => h.textContent)).toEqual(["フロントエンドエンジニア（React / TypeScript）"]);
    });

    test("filters by category, location and employment type", () => {
        renderAt();

        fireEvent.click(screen.getByRole("button", { name: "IT・エンジニア" }));
        expect(jobHeadings()).toHaveLength(2);

        fireEvent.change(screen.getByLabelText("勤務地"), { target: { value: "Montreal" } });
        fireEvent.change(screen.getByLabelText("雇用形態"), { target: { value: "契約社員" } });
        expect(jobHeadings().map((h) => h.textContent)).toEqual(["QA エンジニア（テスト自動化）"]);

        fireEvent.click(screen.getByRole("button", { name: "条件をクリア" }));
        expect(jobHeadings()).toHaveLength(SAMPLE_JOBS.length);
    });

    test("ignores query parameter values that are not in the allowlist", () => {
        renderAt("/?category=unknown&location=%3Cscript%3E&type=x");

        expect(jobHeadings()).toHaveLength(SAMPLE_JOBS.length);
        expect(screen.queryByRole("button", { name: "条件をクリア" })).not.toBeInTheDocument();
    });

    test("shows a message when no job matches", () => {
        renderAt("/?q=no-such-job");

        expect(jobHeadings()).toHaveLength(0);
        expect(screen.getByText(/条件に合うお仕事が見つかりませんでした/)).toBeInTheDocument();
    });
});
