import React from "react";
import { render, screen } from "@testing-library/react";
import { MemoryRouter, Route, Routes } from "react-router-dom";
import JobDetailPage from "./JobDetailPage";

const renderAt = (url: string) =>
    render(
        <MemoryRouter initialEntries={[url]}>
            <Routes>
                <Route path="/jobs/:id" element={<JobDetailPage />} />
            </Routes>
        </MemoryRouter>
    );

describe("JobDetailPage", () => {
    test("shows the job details", () => {
        renderAt("/jobs/1001");

        expect(screen.getByRole("heading", { level: 1, name: "日本食レストランのホールスタッフ" })).toBeInTheDocument();
        expect(screen.getByText("Sakura Dining Vancouver")).toBeInTheDocument();
        expect(screen.getByRole("button", { name: "この求人に応募する" })).toBeDisabled();
        expect(screen.getByRole("link", { name: /お仕事一覧へ戻る/ })).toHaveAttribute("href", "/");
    });

    test("shows a not-found message for an unknown id", () => {
        renderAt("/jobs/9999");

        expect(screen.getByRole("heading", { level: 1, name: "お仕事が見つかりませんでした" })).toBeInTheDocument();
    });
});
