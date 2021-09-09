import React from "react";
import {Image, PageHeader} from "antd";

export default function Header() {
  return (
    <a href="/" /*target="_blank" rel="noopener noreferrer"*/>
      <PageHeader
        title="Decentralized Staker"
        subTitle="Stake your ETH for a good cause!"
        style={{ cursor: "pointer" }}
        avatar={{ src: 'https://static.vecteezy.com/system/resources/previews/000/553/381/original/steak-vector.jpg' }}
      />
    </a>
  );
}
