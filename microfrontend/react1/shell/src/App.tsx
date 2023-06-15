import React, { Suspense } from "react";
import "./App.scss";
import TopNav from "../@mf-types/TopNav/TopNav"
import LeftNav from "../@mf-types/LeftNav/LeftNav"

const TopNavComponent = React.lazy(() => import("TopNav/TopNav")) as unknown as typeof TopNav;
const LeftNavComponent = React.lazy(() => import("LeftNav/LeftNav")) as unknown as typeof LeftNav;
const ItemDetailsComponent = React.lazy(() =>import("ItemDetails/ItemDetails"));

export default function () {
    return (
        <Suspense fallback={<div>Loading...</div>}>
            <section>
                <TopNavComponent />
                <div className="flex">
                    <LeftNavComponent />
                    <ItemDetailsComponent />
                </div>
            </section>
        </Suspense>
    )
}