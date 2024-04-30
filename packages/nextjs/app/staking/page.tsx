"use client";

import React from "react";
import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";

//import projectMetadata from "../../metaData";
//import projects from "../../projectData";
//import { Metadata } from "next";

// export const metadata: Metadata = {
//   title: "Hyperstaker",
//   description: "Your Insight, Everyone's Reward.",
// };

export default function Page() {
  const { data: stakedAmount } = useScaffoldReadContract({
    contractName: "HyperStaking",
    functionName: "stakedAmount",
    args: ["0x63A32F1595a68E811496D820680B74A5ccA303c5", 0x100000000000000000000000000000001n],
  });
  const { data: units } = useScaffoldReadContract({
    contractName: "HypercertMinter",
    functionName: "unitsOf",
    args: ["0x610178dA211FEF7D417bC0e6FeD39F05609AD788", 0x100000000000000000000000000000001n],
  });
  console.log("stake: stakedAmount", stakedAmount);
  const displayStakedAmount = (amount: bigint | undefined) => {
    return amount ? amount.toString() : "Loading...";
  };
  // console.log("stake: units", units?.toString());
  return (
    <div className="container mx-auto">
      <div className="flex flex-row">
        <h1>Staking</h1>
        <p>Staked Amount: {displayStakedAmount(stakedAmount)}</p>
        <p>Units of Amount: {units?.toString()}</p>
      </div>
    </div>
  );
}
